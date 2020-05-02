--Warrior's Rage
function c11511054.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCondition(c11511054.condition)
	e1:SetTarget(c11511054.target)
	e1:SetOperation(c11511054.operation)
	c:RegisterEffect(e1)
end
function c11511054.filter(c,e,tp,cond)
	return c:IsSetCard(0xfff) and c:IsType(TYPE_XYZ) and ( cond or c:IsCanBeSpecialSummoned(e,0,tp,false,false) )
end
function c11511054.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.IsExistingMatchingCard(c11511054.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,true)
end
function c11511054.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c11511054.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c11511054.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local c=e:GetHandler()
	if g:GetCount()>0  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c11511054.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
        local tc=sg:GetFirst()
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		c:CancelToGrave()
		Duel.Overlay(tc,c)
    end
end

