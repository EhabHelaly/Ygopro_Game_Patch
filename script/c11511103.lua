--Wind-Horned Tiger
function c11511103.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11511103)
	e1:SetCost(c11511103.spcost)
	e1:SetOperation(c11511103.spop)
	c:RegisterEffect(e1)
	--sp summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11511103,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11511102)
	e2:SetTarget(c11511103.target)
	e2:SetOperation(c11511103.operation)
	c:RegisterEffect(e2)

end
function c11511103.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11511103.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c11511103.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c11511103.spop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11511103.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,rc:GetLevel(),rc:GetRace())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11511103.spfilter1(c,e,tp)
	return c:IsSetCard(0xffe) and c:IsAbleToHandAsCost() and Duel.IsExistingMatchingCard(c11511103.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel(),c:GetRace())
end
function c11511103.spfilter2(c,e,tp,lv,rc)
	return c:IsSetCard(0xffe) and c:GetLevel()==lv and c:GetRace()~=rc and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11511103.filter(c,e,tp)
	return c:IsCode(39111158) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11511103.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11511103.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c11511103.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11511103.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
