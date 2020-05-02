--Dragonilian Arclight
function c11511214.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetTarget(c11511214.sptg)
	e1:SetOperation(c11511214.spop)
	c:RegisterEffect(e1)
end
function c11511214.filterG(c,e,tp)
	return c:IsSetCard(0xffd) and c:IsAbleToGraveAsCost() 
	and Duel.IsExistingMatchingCard(c11511214.filterS,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c:GetLevel(),c:GetAttribute())
end
function c11511214.filterS(c,e,tp,lv,att)
	return c:IsSetCard(0xffd) and c:GetLevel()>lv and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c11511214.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11511214.filterG,tp,LOCATION_MZONE,0,1,nil,e,tp) end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c11511214.filterG,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c11511214.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc = e:GetLabelObject()
	local att=tc:GetAttribute()
	local lv =tc:GetLevel()
	Duel.SendtoGrave(tc,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c11511214.filterS,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,lv,att)
	if g2:GetCount()>0 then
		Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
	end
end
