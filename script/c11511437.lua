--SW Ally Zhang He
function c11511437.initial_effect(c)
	c:SetUniqueOnField(1,0,11511437)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xffb),1,1,aux.NonTuner(Card.IsCode,11511425),1,1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c11511437.spcon)
	e1:SetTarget(c11511437.sptg)
	e1:SetOperation(c11511437.spop)
	c:RegisterEffect(e1)
	--battle destroy
	local e2=Effect.CreateEffect(c)	
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdcon)
	e2:SetTarget(c11511437.tg)
	e2:SetOperation(c11511437.op)
	c:RegisterEffect(e2)

end
function c11511437.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c11511437.mgfilter(c,e,tp,sc,mg,to)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),REASON_SYNCHRO)==REASON_SYNCHRO and c:GetReasonCard()==sc
		and ( (to==LOCATION_HAND and c:IsAbleToHand() ) or (to==LOCATION_MZONE and c:IsCanBeSpecialSummoned(e,0,tp,false,false) ) )
end
function c11511437.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	mg=mg:Filter(aux.NecroValleyFilter(c11511433.mgfilter),nil,e,tp,e:GetHandler(),mg,LOCATION_MZONE)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c11511437.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetHandler():GetMaterial()
	mg=mg:Filter(aux.NecroValleyFilter(c11511437.mgfilter),nil,e,tp,e:GetHandler(),mg,LOCATION_MZONE)
	if mg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if mg:GetCount()>1 then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			mg=mg:Select(tp,1,1,nil)
		end
		if Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP) then 
			mg=e:GetHandler():GetMaterial()
			mg=mg:Filter(aux.NecroValleyFilter(c11511433.mgfilter),nil,e,tp,e:GetHandler(),mg,LOCATION_HAND)
			if mg:GetCount()>0 then
				Duel.SendtoHand(mg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,mg)
			end
		end
	end
end
function c11511437.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c11511437.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
